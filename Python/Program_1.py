print('Hello World')
print('Erstelle die Liste und Print-all')
a = [1,2,3,4,5,6]
for i in a:
  print(i)
print('Direkt Zugriff auf 3')
print(a[2])
print('Append 10')
a.append(10)
for i in a:
  print(i)
m = max(a)
print(f"Höchster Wert: {m}")
print('Create Tuple')
t = ('Peter',1,33)
print(t)