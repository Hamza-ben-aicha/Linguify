class UserModel {
   String? email;
   String? password;
   String? fullName;
   String? country;
   List<String>? interests;
   List<String>? goals;
   List<String>? languagesToLearn;
   String? nativeLanguage;
   String? accountImage;
   DateTime? birthdate;
   String? bio;
   String? gender;

   UserModel({
      this.email,
      this.password,
      this.fullName,
      this.country,
      this.interests,
      this.goals,
      this.languagesToLearn,
      this.nativeLanguage,
      this.accountImage,
      this.birthdate,
      this.bio,
      this.gender,
   });

   // Convert UserModel to JSON
   Map<String, dynamic> toJson() {
      return {
         'email': email,
         'password': password,
         'full_name': fullName,
         'country': country,
         'interests': interests,
         'goals': goals,
         'languages_to_learn': languagesToLearn,
         'native_language': nativeLanguage,
         'account_image': accountImage,
         'birthdate': birthdate?.toIso8601String(),
         'bio': bio,
         'gender': gender,
      };
   }

   // Create UserModel from JSON
   factory UserModel.fromJson(Map<String, dynamic> json) {
      return UserModel(
         email: json['email'],
         password: json['password'],
         fullName: json['full_name'],
         country: json['country'],
         interests: List<String>.from(json['interests']),
         goals: List<String>.from(json['goals']),
         languagesToLearn: List<String>.from(json['languages_to_learn']),
         nativeLanguage: json['native_language'],
         accountImage: json['account_image'],
         birthdate: DateTime.parse(json['birthdate']),
         bio: json['bio'],
         gender: json['gender'],
      );
   }
}
