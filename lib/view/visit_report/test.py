# Given dictionary and list
my_dict = {'name': 'Alice', 'age': 30, 'city': 'New York'}
my_list = [5, 15, 25, 35]

my_dict['occupation'] = 'Engineer'
print(my_dict)
print(my_list)
my_list.pop()
print(my_list)

new_list = list(my_dict.values()) + my_list
print("New List:", new_list)
