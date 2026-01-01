import 'package:flutter/material.dart';
import 'package:steady/theme/appColor.dart';

class Startscreen extends StatelessWidget {
  const Startscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      
      
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 4,),
              Image.asset('assets/images/illustration-container.png'),
              SizedBox(height: 30,),
              const Text('Build habits without pressure',
              
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900,fontSize: 35,),),
              SizedBox(height: 20,),
        
              const Text('Offline. Calm. Consistent.',style: TextStyle(color: AppColors.textSecondary,fontSize: 20),),
              SizedBox(height: 20,),
              
              const Spacer(flex: 3,), 
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: ()=>{}, 
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  
                  child: Text('Start',style: 
                  TextStyle(color: AppColors.secondary),),
                ),
              )
        
            
            ]
          
          ),
          
        ),
      )
      
    );
  }
}