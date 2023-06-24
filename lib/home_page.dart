import 'package:allen/feature_box.dart';
import 'package:allen/openai_services.dart';
import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:animate_do/animate_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int start=200;
  int delay=200;
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedcontent;
  String? generatedimageurl;
  final OpenAIService openAIService = OpenAIService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();

    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> SystemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Allen')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png'),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //chat bubble
            FadeInRight(
              child: Visibility(
                visible: generatedimageurl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  margin: const EdgeInsets.symmetric(horizontal: 40)
                      .copyWith(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Pallete.borderColor),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      //topLeft: Radius.zero,
                      bottomLeft: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      generatedcontent == null
                          ? 'Good morning, what can i do for you?'
                          : generatedcontent!,
                      style: TextStyle(
                        color: Pallete.mainFontColor,
                        fontSize: generatedcontent == null ? 20 : 15,
                        fontFamily: 'Cera Pro',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedimageurl != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      generatedimageurl!,
                    )),
              ),
            FadeInLeft(
              child: Visibility(
                visible: generatedcontent == null && generatedcontent == null,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                      top: 10, left: 40, right: 10, bottom: 10),
                  child: const Text(
                    'Here are few new features',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      fontSize: 20,
                      color: Pallete.mainFontColor,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedcontent == null && generatedcontent == null,
              child: Column(
                children: [
                  SlideInRight(
                    delay: Duration(microseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headertext: 'ChatGPT',
                      discriptiontext:
                          'A smarter way to organize and informed with chat gpt',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headertext: 'Dall-E',
                      discriptiontext:
                          'Get inspired and stay creative with your personal assistant',
                    ),
                  ),
                  SlideInRight(
                    delay: Duration(milliseconds: start+ 2*delay),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headertext: 'Smart Voice Assistant',
                      discriptiontext:
                          'Get the best of both worlds with a voice assistant powered',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedimageurl = speech;
                generatedcontent = null;
                setState(() {});
              } else {
                generatedimageurl = null;
                generatedcontent = speech;
                await SystemSpeak(speech);
                setState(() {});
              }
      
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          backgroundColor: Pallete.firstSuggestionBoxColor,
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
