#!/bin/bash
source /etc/profile

readonly PROGPID=$$
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

#install tools
pip install -U huggingface_hub nvitop

nccldir=${PROGDIR}/nccl/build
cudadir=/usr/local/cuda

if [[ -d ${cudadir} ]]; then
    echo "当前cudadir设置在：${cudadir}"
else
    echo "${cudadir}: NOT FOUND!"
fi

procnum=$(nproc)
tool=${PROGDIR}/nccl-tests/build/all_reduce_perf

if [[ ! -f ${tool} ]]; then
cd ${PROGDIR}
rm -fr nccl nccl-test
wget -O nccl.tar.gz https://cos-ops.ppio.cloud/IaaS/gpu-test/nccl.tar.gz && tar zxf nccl.tar.gz
wget -O nccl-tests.tar.gz https://cos-ops.ppio.cloud/IaaS/gpu-test/nccl-tests.tar.gz && tar zxf nccl-tests.tar.gz

#nccl,默认编译在build目录下，下面用:
cd ${PROGDIR}/nccl
make CUDA_HOME=${cudadir}  -j ${procnum}
#编译nccl-test:
cd ${PROGDIR}/nccl-tests
make CUDA_HOME=${cudadir} NCCL_HOME=${nccldir} -j ${procnum}

if [[ ! -f ${tool} ]]; then
    echo "nccl-test compile error"
    exit 1
fi

fi

function run_nccl_test() {
    cd ${PROGDIR}/nccl-tests

    cardnum=$1

    export LD_LIBRARY_PATH=${cudadir}/lib64:${nccldir}/lib:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

    ldd ${tool}

    if [[ ${cardnum} == "4" ]]; then
        echo "正在进行4卡卡间通信测试,测试前4张卡...."
        echo "测试命令为：${tool} -b 1024 -e 1G -f 2 -g 4"
        export CUDA_VISIBLE_DEVICES=0,1,2,3
        ${tool} -b 1024 -e 1G -f 2 -g 4
        echo "正在进行4卡卡间通信测试,测试后4张卡...."
        echo "测试命令为：${tool} -b 1024 -e 1G -f 2 -g 4"
        export CUDA_VISIBLE_DEVICES=4,5,6,7
        ${tool} -b 1024 -e 1G -f 2 -g 4
    fi

}

function run_bandwidth_test() {
    cd ${PROGDIR}

    rm -fr cuda-samples
    wget -O cuda-samples.tar.gz https://cos-ops.ppio.cloud/IaaS/gpu-test/cuda-samples.tar.gz && tar zxf cuda-samples.tar.gz

    cd ${PROGDIR}/cuda-samples/Samples/5_Domain_Specific/p2pBandwidthLatencyTest
    make
    ./p2pBandwidthLatencyTest |tee ${PROGDIR}/p2pBandwidthLatencyTest.log
}


run_nccl_test 4 | tee ${PROGDIR}/nccl_test_4gpu.txt

run_bandwidth_test

cd ${PROGDIR}
python3 checkperformance.py