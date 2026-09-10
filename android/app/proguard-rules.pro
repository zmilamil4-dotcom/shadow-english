# google_mlkit_text_recognition: we only use TextRecognitionScript.latin.
# The plugin references optional script recognizers we don't depend on;
# tell R8 to ignore them instead of failing the build.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
