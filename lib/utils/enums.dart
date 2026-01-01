enum Day{
  monday,tuesday,wednesday,thursday,friday,saturday,sunday
}
enum MoodType {
  motivate(image: 'motivate.png', title: 'Motivation'),
  normal(image: 'okay.png', title: 'Okay'),
  stressed(image: 'stressed.png', title: 'Stressed'),
  tired(image: 'tired.png', title: 'Tired');

  final String image;
  final String title;

  const MoodType({required this.image, required this.title});
}

enum AllTab{
  home,add,tracker,setting
}