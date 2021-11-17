#nvcc main.cu -rdc=true -lineinfo -lcudadevrt -arch=sm_60 -o render
nvcc main.cu -arch=sm_60 -o render
