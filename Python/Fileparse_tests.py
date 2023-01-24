import os
import xml.etree.ElementTree as ET

# Print working directory
print(os.getcwd())

with open('python/testfile.txt', 'r') as reader:
    # Read & print the entire file testfiles.txt
    print(reader.read())

# parese XML file
mytree = ET.parse('apex/codetemplate.xml')
myroot = mytree.getroot()
print(myroot)
print(myroot.tag)
print(myroot.attrib)
print(myroot[0].tag)
for x in myroot[0]:
    print(x.tag, x.attrib)
for x in myroot[0]:
        print(x.text)
for x in myroot.findall('row'):
    key =x.find('key').text
    statement = x.find('value').text
    print(key, statement)
# Write a file
with open('python/outputtest.txt', 'w') as writer:
    writer.write(myroot[0].tag + '\n')
    print('File ' + 'written')