//NULLABLE TYPES
/*
void main(){
  int? a; 
  a = null;
  print('a is $a');
}*/

//NULLABLE TYPE PARAMETERS FOR GENERICS
/*
void main(){
List<String> aListOfStrings = ['One', 'Two', 'Three'];
List<String>? aNullableListOfStrings;
List<String?> aListOfNullableStrings = ['One', null, 'Three'];

print('aListOfString is $aListOfStrings');
print('aNullableListOfStrings is $aNullableListOfStrings');
print('aListOfNullableStrings is $aListOfNullableStrings');
}*/

//THE NULL ASSERTION OPERATOR ( ! )
/*
int? couldReturnNullBuyDoesnt() => -3;
int? couldBeNullButIsnt = 1;
void main(){
List<int?> listThatCouldHoldNulls = [2, null, 4];

int a = couldBeNullButIsnt!;
int b = listThatCouldHoldNulls.first!;
int c = couldReturnNullBuyDoesnt()!.abs();

print('a is $a');
print('b is $b');
print('c is $c');
}*/

//THE 'REQUIRED' KEYWORD
/*int addThreeValues({
required int first,
required int second,
required int third,
}) {
   return first + second + third;
}

void main(){
final sum =  addThreeValues(
  first: 2,
  second: 5,
  third: 3,
);

print(sum);
}*/

//TYPE PROMOTION

/*void main(){

  Object a = 'This is a string';
if (a is String){
  print(a.length);

}*/
/*void main(){
String   text;
/*if (DateTime.now().hour < 12){
text = 'It´s a morning! let´s make aloo paratha!';
} else {
text = "It´s afternoon! Let´s make biryani";
}*/

print (text);
print (text.length);

}*/

//THE LATE KEYWORD
/*
class Meal{
 late String description;

 void setDescription(String str)
{
  description = str;
}
}

void main(){

  final myMeal = Meal();
  myMeal.setDescription('Feijoada');
  print(myMeal.description);
}*/

//AN ADVANCED PATTERN: LATE CIRCULAR REFERENCES
/*
class Team{
late final Coach coach;
}

class Coach{
late final Team team; 
}

void main(){
final myTeam = Team();
final myCoach = Coach();
myTeam.coach = myCoach;
myCoach.team = myTeam;

print('All done!');

}*/

//LATE AND LAZY

int _computeValue(){
  print('In _computeValue...');
  return 3;
}

class CachedValueProvider {
  late final _cache = _computeValue();
  int get value => _cache;
}

void main(){
  print('Calling constructor...');
  var provider = CachedValueProvider();
  print('Getting value...');
  print('The value is ${provider.value}!');
}
