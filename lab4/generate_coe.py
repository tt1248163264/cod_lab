import os
import os.path

filehandler = open('background.coe','w')
for index in range(65536):
	filehandler.write('fff\n');

filehandler.close()
