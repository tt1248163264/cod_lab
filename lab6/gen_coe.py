with open('temp.coe','w') as f:
    #f.writelines('memory_initialization_radix = 16;\n')
    #f.writelines('memory_initialization_vector = \n')
    #for i in range(499):
    #    f.writelines('00000000\n')
    for i in range(256):
        f.writelines('00000000\n')
