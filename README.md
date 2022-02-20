# 2022-02-enterprise-demo 

[![Anchore Enterprise](https://github.com/pvnovarese/2022-02-enterprise-demo/actions/workflows/anchore-enterprise.yaml/badge.svg)](https://github.com/pvnovarese/2022-02-enterprise-demo/actions/workflows/anchore-enterprise.yaml) [![Anchore Weekly](https://github.com/pvnovarese/2022-02-enterprise-demo/actions/workflows/anchore-weekly.yaml/badge.svg)](https://github.com/pvnovarese/2022-02-enterprise-demo/actions/workflows/anchore-weekly.yaml)

Simple demo for Anchore Enterprise, including both Jenkins and GitHub workflow examples.

Partial list of problems in this image:

1. xmrig cryptominer installed at `/xmrig/xmrig`
2. simulated AWS access key in `/aws_access`
3. simulated ssh private key in `/ssh_key`
4. selection of commonly-blocked packages installed (sudo, curl, etc)
5. `/log4j-core-2.14.1.jar` (CVE-2021-44228, et al)
6. CVE-2021-3156 (sudo) provided via hints file (rpm also available)
