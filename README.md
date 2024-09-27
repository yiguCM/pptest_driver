# pptest_driver
#Please ensure that the environment is GCC-12 and Python3
*******************
bash install_driver.sh
*****************

Bidirectional P2P=Enabled Bandwidth Matrix (GB/s)
   D\D     0      1      2      3      4      5      6      7
     0 916.92  49.78  50.40  50.39  40.00  41.79  40.84  41.78
     1  49.85 920.12  50.29  50.26  39.24  41.70  41.87  40.85
     2  50.21  50.69 920.47  50.30  40.01  40.88  41.91  41.72
     3  49.60  50.53  50.43 921.50  39.87  41.73  40.98  41.70
     4  41.73  40.94  41.84  41.68 922.10  49.83  50.60  50.45
     5  40.39  41.87  40.90  41.84  49.55 922.10  50.26  50.28
     6  38.92  41.62  41.90  40.83  49.84  50.65 922.09  50.33
     7  40.18  40.97  41.69  41.85  49.73  50.43  50.47 921.56

/home/test/RTXp2pkernel_installmod/nccl-tests/build/all_reduce_perf -b 1024 -e 1G -f 2 -g 4
# nThread 1 nGpus 4 minBytes 1024 maxBytes 1073741824 step: 2(factor) warmup iters: 5 iters: 20 agg iters: 1 validation: 1 graph: 0
#
# Using devices
#  Rank  0 Group  0 Pid 866559 on GPU-RTX4090-4-4 device  0 [0x01] NVIDIA GeForce RTX 4090
#  Rank  1 Group  0 Pid 866559 on GPU-RTX4090-4-4 device  1 [0x25] NVIDIA GeForce RTX 4090
#  Rank  2 Group  0 Pid 866559 on GPU-RTX4090-4-4 device  2 [0x41] NVIDIA GeForce RTX 4090
#  Rank  3 Group  0 Pid 866559 on GPU-RTX4090-4-4 device  3 [0x61] NVIDIA GeForce RTX 4090
#
#                                                              out-of-place                       in-place
#       size         count      type   redop    root     time   algbw   busbw #wrong     time   algbw   busbw #wrong
#        (B)    (elements)                               (us)  (GB/s)  (GB/s)            (us)  (GB/s)  (GB/s)
        1024           256     float     sum      -1    18.46    0.06    0.08      0    18.56    0.06    0.08      0
        2048           512     float     sum      -1    18.62    0.11    0.16      0    18.30    0.11    0.17      0
        4096          1024     float     sum      -1    18.71    0.22    0.33      0    19.04    0.22    0.32      0
        8192          2048     float     sum      -1    18.91    0.43    0.65      0    18.98    0.43    0.65      0
       16384          4096     float     sum      -1    21.03    0.78    1.17      0    20.23    0.81    1.22      0
       32768          8192     float     sum      -1    21.17    1.55    2.32      0    21.88    1.50    2.25      0
       65536         16384     float     sum      -1    25.25    2.60    3.89      0    25.03    2.62    3.93      0
      131072         32768     float     sum      -1    38.63    3.39    5.09      0    38.54    3.40    5.10      0
      262144         65536     float     sum      -1    62.98    4.16    6.24      0    62.89    4.17    6.25      0
      524288        131072     float     sum      -1    89.57    5.85    8.78      0    93.71    5.59    8.39      0
     1048576        262144     float     sum      -1    118.6    8.84   13.26      0    123.2    8.51   12.77      0
     2097152        524288     float     sum      -1    184.1   11.39   17.09      0    182.2   11.51   17.27      0
     4194304       1048576     float     sum      -1    310.5   13.51   20.26      0    283.2   14.81   22.22      0
     8388608       2097152     float     sum      -1    545.7   15.37   23.06      0    529.5   15.84   23.77      0
    16777216       4194304     float     sum      -1   1021.4   16.43   24.64      0   1008.4   16.64   24.95      0
    33554432       8388608     float     sum      -1   2013.3   16.67   25.00      0   2013.0   16.67   25.00      0
    67108864      16777216     float     sum      -1   4003.2   16.76   25.15      0   3992.8   16.81   25.21      0
   134217728      33554432     float     sum      -1   7967.8   16.85   25.27      0   7968.8   16.84   25.26      0
   268435456      67108864     float     sum      -1    15918   16.86   25.29      0    15921   16.86   25.29      0
   536870912     134217728     float     sum      -1    31829   16.87   25.30      0    31823   16.87   25.31      0
  1073741824     268435456     float     sum      -1    63624   16.88   25.31      0    63640   16.87   25.31      0
# Out of bounds values : 0 OK
# Avg bus bandwidth    : 13.3111
