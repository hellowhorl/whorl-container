#!/bin/sh

sudo echo "sudo mount -t nfs4 warehouse.chompe.rs:/mounts/$NFS_DST /universe" >> bash.bashrc
