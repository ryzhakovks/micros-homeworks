#!/bin/bash

IPAPI=$(ip a | grep -i eth0 | grep -oP 'inet \K[0-9.]+')

IPEXT=$(curl -s 2ip.ru)

sudo kubeadm init --apiserver-advertise-address="$IPAPI" --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans="$IPEXT" | awk '/kubeadm join/{print;getline;print}' >init.output.txt

mkdir /home/ubuntu/.kube

sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config

sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
