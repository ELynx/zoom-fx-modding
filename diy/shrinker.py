# expect strip6x from toolset to be available as direct command
# see Library section of repository for toolset download

# works on one folder at a time

import os
import tempfile

inputFilesAndFolders = os.listdir()

inputFiles = []

for inputFileOrFolder in inputFilesAndFolders:
    if os.path.isfile(inputFileOrFolder):
        if inputFileOrFolder.endswith('ZDL'):
            inputFiles.append(inputFileOrFolder)

for inputFile in inputFiles:
    with open(inputFile, 'rb') as original:
        sectionNull = original.read(4)
        sectionSizeBlablabla = original.read(4 + 4)
        sectionSizeHeaders = original.read(4)
        headersSize = int.from_bytes(sectionSizeHeaders, 'little')
        sectionSizeElfSize = original.read(4)
        restOfHeaders = original.read(headersSize)
        anElf = original.read()
        assert anElf[0] == 127  # 0x7F
        assert anElf[1] == 69  # E
        assert anElf[2] == 76  # L
        assert anElf[3] == 70  # F
        original.close()
        os.rename(inputFile, inputFile + '.bak')
        (fd, path) = tempfile.mkstemp()
        try:
            with os.fdopen(fd, 'wb') as tmp:
                tmp.write(anElf)
            rv = os.system('strip6x ' + path)
            assert rv == 0
            with open(path, 'rb') as tmp:
                aSmallerElf = tmp.read()
                with open(inputFile, 'wb') as shrunk:
                    shrunk.write(sectionNull)
                    shrunk.write(sectionSizeBlablabla)
                    shrunk.write(sectionSizeHeaders)
                    shrunk.write(len(aSmallerElf).to_bytes(4, 'little'))
                    shrunk.write(restOfHeaders)
                    shrunk.write(aSmallerElf)

                    print (inputFile)
                    print (' ELF section before ' + str(len(anElf)))
                    print (' ELF section after  ' + str(len(aSmallerElf)))
        finally:
            os.remove(path)
