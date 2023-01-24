import os
import xml.etree.ElementTree as ET
import csv

# Print working directory
print(os.getcwd())

with open('python/testfile.txt', 'r') as reader:
    # Read & print the entire file testfiles.txt
    print(reader.read())

# Read / parse XML file
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
# Write a file.csv
with open('python/templates.csv', mode='w') as templates:
    templates_writer = csv.writer(templates, delimiter=';', quotechar='"', quoting=csv.QUOTE_ALL)

    templates_writer.writerow(['Key', 'Value'])
    for x in myroot.findall('row'):
        key =x.find('key').text
        statement = x.find('value').text
        templates_writer.writerow([key, statement])
print('File written')