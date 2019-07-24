###############################################################
#
#Create MrVBF maps
#
#by Devjyoti Mitra, devjyoti.mitra@rms.com, 12/16
#
#
###############################################################
#
#! /usr/bin/Rscript --vanilla
rm(list=ls(all=TRUE))
options(stringsAsFactors = FALSE)

################################################
# Initial processing

uinfo <- data.frame(t(Sys.info()))
Rinfo <- data.frame(t(R.Version()))
install.packages(c('rgdal','raster','RSAGA'), dependencies=TRUE, 
					repos = "https://cran.cnr.berkeley.edu/")
					
library(rgdal)
library(RSAGA)
library(raster)
library(tools)

############
# 9x9 Focal Mean DEM

##Setting up SAGA environment
myenv <- rsaga.env(workspace=paste0(getwd(),"/temp"), path="C:/saga620/saga-6.2.0_x64")


###Get SAGA grids
files <- list.files('./inDEM', pattern = '\\.tif$')
files.list <- tools::file_path_sans_ext(files)

##MrVBF Maps
##To get library:
cat('\n')
rsaga.get.libraries(myenv$modules)
cat('\n')

##To get module in the required library:
#rsaga.get.modules("ta_morphometry", env = myenv)
#rsaga.get.modules("io_gdal", env = myenv)

##Output SAGA MrVBF Directory
in.dir <- paste0(getwd(),"/inDEM")
out.dir <- paste0(getwd(),"/outMRVBF/SAGA_GRIDS/MRVBF")
out.dir_1 <- paste0(getwd(),"/outMRVBF/SAGA_GRIDS/MRRTF")
out.path <- paste0(getwd(),"/outMRVBF/GeoTiFF_MRVBF")

##Clear output directories ===================
unlink(out.path,recursive = TRUE)
unlink(out.dir,recursive = TRUE)
unlink(out.dir_1,recursive = TRUE)

dir.create(out.path)
dir.create(out.dir)
dir.create(out.dir_1)

#standard parameters from Dev =================
cat('\n')
cat('\n')
cat("=================================================================================")
cat('\n')
cat('INITIATING MRVBF CALCULATIONS (POWERED BY SAGA-GIS 6.2.0)')
cat('\n')
cat("=================================================================================")
cat('\n')
cat('\n')
for(i in 1:length(files)){
  tmp.ras <- raster(paste(in.dir, files[i],sep = "/"))
  
  #Check for projected CRS ====================
  ext_box <- as(extent(tmp.ras),'SpatialPolygons')
  crs(ext_box) <- projection(tmp.ras)
  chk_prj <- is.projected(ext_box)
  
  if(chk_prj == TRUE){
    if(res(tmp.ras)[1] == 25){
      t_slp <- 16
    }else{
      t_slp <- 116.57*((res(tmp.ras)[1])^(-0.62))
    }
    cat('\n')
    cat('\n')
    cat("=======================================================================================")
	  cat('\n')
    cat(paste0('CREATING MRVBF MAP FOR FILENAME: ',files[i],' (',i, ' OF ',length(files),')'))
	  cat('\n')
    cat("=======================================================================================")
    cat('\n')
    
    ##Inputs for Mrvbf
    t_pctl_v = "0.4000"
    t_pctl_r = "0.3500"
    p_slope = "4.00"  
    p_pctl = "3.00"
    max_res = "100"
    
    rsaga.geoprocessor("ta_morphometry", module = 8, env = myenv,
                       param = list(DEM = paste(in.dir, files[i],sep = "/"),
                                    MRVBF = paste0(out.dir,'/' ,files.list[i],'.sgrd'),
                                    T_SLOPE = as.character(t_slp),
                                    T_PCTL_V = t_pctl_v,
                                    T_PCTL_R = t_pctl_r,
                                    P_SLOPE = p_slope,  
                                    P_PCTL = p_pctl,
                                    MAX_RES = max_res
                       ))
    
    #out.grd <- strsplit(files[i], ".tif")
    out.grd <- files.list[i]
    d1 <- paste(out.dir, out.grd, sep = "/")
    d <- paste(d1,".sgrd",sep='')
    
    c1 <- paste(out.path, out.grd, sep = "/")
    c <- paste(c1, "_MRVBF.tif", sep ='')
    
    rsaga.geoprocessor("io_gdal", module = 2, env = myenv,
                       param = list(
                         GRIDS = paste(d),
                         FILE = paste(c)
                       ))
    
    tmp.df <- data.frame(DEM = paste(in.dir, files[i],sep = "/"),
                         DEMRES = res(tmp.ras)[1],
                         MRVBF = paste(c),
                         T_SLOPE = as.character(t_slp),
                         T_PCTL_V = t_pctl_v,
                         T_PCTL_R = t_pctl_r,
                         P_SLOPE = p_slope,  
                         P_PCTL = p_pctl,
                         MAX_RES = max_res)
    
    if(i == 1){
      repinp <- tmp.df
    }else{
      repinp <- rbind(repinp, tmp.df)
    }
    
  }else{
    cat('\n')
    cat('\n')
    cat("=========================================================")
    cat(paste0('SKIPPING ',i, ' OF ',length(files)))
    cat('CRS IS NOT PROJECTED!! CANNOT CALCULATE MRVBF.....')
    cat("=========================================================")
    cat('\n')
    cat('\n')
  }
  
}

cat('\n')
cat('================================================')
cat('\n')
cat("Creating log file \n")
cat('================================================')
cat('\n')

tStamp <- as.character(format(Sys.time(), "%Y%m%d_%Hh%Mm"))


report <- paste0(
  paste0("  ", "\n"),
  paste0("01. USER AND MACHINE DETAILS " ,"\n"),
  paste0("===================================================================================", "\n"),
  paste0("  ", "\n"))

cat(report, file = (paste0("log/",tStamp, "_Report",".txt")), append=T)

cat(capture.output(print(uinfo), file=(paste0("log/",tStamp, "_Report",".txt")),append = T))


report <- paste0(
  paste0("  ", "\n"),
  paste0("02. R VERSION DETAILS " ,"\n"),
  paste0("===================================================================================", "\n"),
  paste0("  ", "\n"))

cat(report, file = (paste0("log/",tStamp, "_Report",".txt")), append=T)
cat(capture.output(print(Rinfo), file=(paste0("log/",tStamp, "_Report",".txt")),append = T))


report <- paste0(
  paste0("  ", "\n"),
  paste0("03. MRVBF INPUT DETAILS " ,"\n"),
  paste0("===================================================================================", "\n"),
  paste0("  ", "\n"))

cat(report, file = (paste0("log/",tStamp, "_Report",".txt")), append=T)
cat(capture.output(print(repinp), file=(paste0("log/",tStamp, "_Report",".txt")),append = T))


report <- paste0(
  paste0("  ", "\n"),
  paste0("SMRVBF written by DEVJYOTI MITRA, dmitra@rms.com (2019)","\n"),
  paste0("  ", "\n"))

cat(report, file = (paste0("log/",tStamp, "_Report",".txt")), append=T)

message((paste0("Log File Path:", getwd(),"/log/",tStamp, "_Report",".txt")))
message('=====================================================================================')

message('Deleting temporary data')
message('================================================')
unlink(out.dir,recursive = TRUE)
unlink(out.dir_1,recursive = TRUE)

dir.create(out.dir)
dir.create(out.dir_1)


####################End ---------------------------------




