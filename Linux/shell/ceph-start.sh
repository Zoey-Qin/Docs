#!/bin/bash
systemctl enable ceph-mon.target
systemctl start ceph-mon.target
systemctl enable ceph-osd.target
systemctl start ceph-osd.target
systemctl enable ceph-mgr.target
systemctl start ceph-mgr.target
systemctl enable ceph-radosgw.target
systemctl start ceph-radosgw.target
systemctl enable nfs-ganesha
systemctl start nfs-ganesha
systemctl enable haproxy
systemctl start haproxy
systemctl enable keepalived
systemctl start keepalived






