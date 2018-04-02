#!/bin/bash

service nginx start
service mysql start

exec $@
