### Login to the machine and partition the disk into a filesystem and migrate the data 

<!-- Format the disk into a filesystem-->
```
mkfs.ext4 /dev/vdb
mount /dev/vdb /home/ubuntu/disk
chmod 777 /home/ubuntu/disk
mkdir /home/ubuntu/disk/data
scp username@remote_1:/file/to/send username@remote_2:/where/to/put
scp pa11@farm4-login:/file/to/send ubuntu@172.27.83.29:/home/ubuntu/disk/

```### Mount the volume onto your running instance

```

sudo mount /dev/vdb /home/ubuntu/disk
chmod 777 /home/ubuntu/disk/data

```

### Run Docker and mount volume mounted on the container


 docker run -e PASSWORD=123 -p 80:8787 -v /home/ubuntu/disk:/home/rstudio/data bioconductor/devel_base2 

