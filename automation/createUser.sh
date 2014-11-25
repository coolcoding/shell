#!/bin/bash
# create user

for name in tom jerry joe jane bean
do
    useradd $name
    echo redhat | passwd --stdin $name
done
