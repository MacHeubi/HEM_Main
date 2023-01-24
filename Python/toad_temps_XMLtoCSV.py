import os
import xml.etree.ElementTree as ET
import csv

# Read / parse XML file
mytree = ET.parse('apex/toad_code_templ.xml')
# mytree = ET.parse('python/testtoad.xml')
myroot = mytree.getroot()
print('Load all template within ' + myroot.tag)
with open('apex/templates_tsr.csv', mode='w') as templates:
    templates_writer = csv.writer(templates, delimiter=';', quotechar='"', quoting=csv.QUOTE_ALL)

    templates_writer.writerow(['Description','Advanced','Key', 'Value'])
    cnt = 0
    for x in myroot.findall('TEMPLATE'):
        desc = x.find('DESCRIPTION').text
        statement = x.find('CODE').text
        cnt += 1
        templates_writer.writerow([desc, x.attrib["advanced"], x.attrib["name"], statement])
print(f"File ist fertig mit {cnt} Zeilen")
# Write a file.csv