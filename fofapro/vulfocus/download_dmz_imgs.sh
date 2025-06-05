
imgs=(
"vulfocus/struts2-cve_2020_17530:latest"
"vulfocus/weblogic-cve_2019_2725:latest"
"c4pr1c3/vulshare_nginx-php-flag:latest"
)

for img in "${imgs[@]}"; do
    docker pull "$img"
done
