with open('cod_lab6.coe','w') as f:
    for i in range(499):
        f.writelines('00000000\n')
    for i in range(65024):
        f.writelines('0fff0000\n')
