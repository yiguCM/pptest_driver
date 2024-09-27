
import os

def get_nccl():
    modelname = "/nccl_test_4gpu.txt"
    path =os.getcwd()
    filename = path + modelname
    with open(filename, 'r', encoding="UTF-8") as f:
        lines = f.readlines()
        for line in lines:
            if "Avg bus bandwidth" in line:
                return line.split()[5]

def get_p2p():
    flag=0
    index=0
    modelname="/p2pBandwidthLatencyTest.log"
    path=os.getcwd()
    filename=path+modelname
    with open(filename, 'r', encoding="UTF-8") as f:
        lines = f.readlines()
        for line in lines:
            if "Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)" in line:
                flag=1
            if flag == 1:
                index+=1
            if index == 3:
                return line.split()[2]

if __name__ == '__main__':
    print('\n\n=============================Start check=================================')
    p2p = float(get_p2p())
    nccl = float(get_nccl())
    if p2p > 40 and nccl > 12:
        print("********************")
        print("*       pass       *")
        print("********************")
    else:
        print("********************")
        print("*       fail       *")
        print("********************")




