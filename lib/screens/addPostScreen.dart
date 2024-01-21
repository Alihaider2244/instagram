import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/Utils/Utils.dart';
import 'package:instagram_clone/Utils/colors.dart';
import 'package:instagram_clone/Utils/Pickimage.dart';
import 'package:instagram_clone/Models/userModel.dart';
import 'package:instagram_clone/Utils/MediaQuery.dart';
import 'package:instagram_clone/Provider/UserProvider.dart';
import 'package:instagram_clone/resources/Auth_methods.dart';
// ignore_for_file: use_build_context_synchronously

class AddPostScreen extends StatefulWidget {
  AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _loading = false;
  _selectImage() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Create a post',
            style: TextStyle(color: primaryColor),
          ),
          titlePadding: const EdgeInsets.all(10),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Take a photo',
                style: TextStyle(color: primaryColor),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List? file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Choose from Gallery',
                style: TextStyle(color: primaryColor),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Cancel',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  _selectImage();
                  controller.clear();
                },
                icon: const Icon(Icons.upload)))
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  clearImage();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      _loading = true;
                    });

                    String valuee = await AuthMethods().UploadPostToFirebase(
                        controller.text,
                        _file!,
                        user.uid,
                        user.username,
                        user.photoURL);

                    setState(() {
                      _loading = false;
                    });

                    if (valuee == 'success') {
                      Utils().showSnackbar(context, 'Posted');
                      clearImage();
                    } else {
                      Utils().showSnackbar(context, valuee.toString());
                      clearImage();
                    }
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: blueColor),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 2,
                      child: _loading
                          ? const LinearProgressIndicator(
                              color: blueColor,
                            )
                          : Container(),
                    ),
                  ),
                  const SizedBox(
                    height: kTextTabBarHeight - 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user.photoURL.toString()),
                        ),
                      ),
                      SizedBox(
                        width: HeightWidt().width(context) * .5,
                        child: Center(
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write a caption...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
