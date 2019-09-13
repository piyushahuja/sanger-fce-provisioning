FROM  bioconductor/devel_base2
# base2: Contains R, RStudio, and a single Bioconductor package (BiocManager, providing the install() function for installing additional packages). Also contains many system dependencies for Bioconductor packages. Useful when you want a relatively blank slate for testing purposes. R is accessible via the command line or via RStudio Server.
# core2: Built on base2, so it contains everything in base2, plus a selection of core Bioconductor packages. See the full list.
# To run RStudio Server:
# docker run -e PASSWORD=<pickYourPassword> -p 8787:8787 ourImageName
# You can then open a web browser pointing to your docker host on port 8787. If you’re on Linux and using default settings, the docker host is 127.0.0.1 (or localhost, so the full URL to RStudio would be http://localhost:8787). If you are on Mac or Windows and running Docker Toolbox, you can determine the docker host with the docker-machine ip default command. In the above command -e PASSWORD= is setting the rstudio password and is required by the rstudio docker image. It can be whatever you like except it cannot be rstudio. Log in to RStudio with the username rstudio and whatever password was specified.

WORKDIR /team170

# to make sure R will find the libs
RUN R .libPaths('/Rlibs') 

# COPY requirements file 
COPY install.R /team170

RUN Rscript install.R

# Install Miniconda
# RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

COPY . team170

EXPOSE 8787
# RUN R Studio on port 8787
CMD ["./entrypoint.sh"]


# docker service create \
#      --mount 'type=volume,src=<VOLUME-NAME>,dst=<CONTAINER-PATH>,volume-driver=local,volume-opt=type=nfs,volume-opt=device=<nfs-server>:<nfs-path>,"volume-opt=o=addr=<nfs-address>,vers=4,soft,timeo=180,bg,tcp,rw"'
#     --name myservice \
#     <IMAGE>


# Mount a volume
# It is possible to mount/map an additional volume or directory. This might be useful for say mounting a local R install directory for use on the docker. The path on the docker image that should be mapped to the additional volume is /usr/local/lib/R/host-site-library. The follow example would mount my locally installed packages to this docker directory. In turn, that path is automatically loaded in the R .libPaths on the docker image and all of my locally installed package would be available for use.

# sudo docker run -v /home/lori/R/x86_64-pc-linux-gnu-library/3.5-BioC-3.8:/usr/local/lib/R/host-site-library -it <name> 