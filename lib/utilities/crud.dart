import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' show basename;

class Curd {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequests(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {}
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      var length = await file.length();
      var stream = http.ByteStream(file.openRead());

      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFiles(
      String url, Map data, File? file, List<File> images) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      if (file != null) {
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());

        var multipartFile = http.MultipartFile('file', stream, length,
            filename: basename(file.path));
        request.files.add(multipartFile);
      }

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      if (images.isNotEmpty) {
        // print('object');
        List<http.MultipartFile> newList = <http.MultipartFile>[];
        for (int i = 0; i < images.length; i++) {
          var length = await images[i].length();
          var stream = http.ByteStream(images[i].openRead());
          var multipartFile = http.MultipartFile("po[]", stream, length,
              filename: basename(images[i].path));
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
      } else {
        // print('No More Images');
      }

      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestWithFilesWithOutFile(
      String url, Map data, List<File> images) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      if (images.isNotEmpty) {
        List<http.MultipartFile> newList = <http.MultipartFile>[];
        for (int i = 0; i < images.length; i++) {
          var length = await images[i].length();
          var stream = http.ByteStream(images[i].openRead());
          var multipartFile = http.MultipartFile("po[]", stream, length,
              filename: basename(images[i].path));
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
      } else {
        // print('No More Images');
      }

      var myrequest = await request.send();

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  postRequestNotifications(String title, String name, String nsid) async {
    try {
      var response = await http.post(
          Uri.parse('https://onesignal.com/api/v1/notifications'),
          headers: {
            'Content-Type': 'application/json',
            'authorization':
                'Basic YWM0ZTViNTctZGMxOS00ZjllLWJhY2EtZmVlYzQ1ZjRkMjM0'
          },
          body: json.encode({
            "app_id": "20f2a871-16a9-4930-b063-4f0a3860153e",
            "included_segments": ["Subscribed Users"],
            "data": {"news_id": nsid},
            "headings": {"ar": title, "en": title},
            "contents": {"ar": name, "en": name}
          }));

      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        // print("Error ${response.statusCode}");
      }
    } catch (e) {
      return 'Error';
    }
  }

  // postRequestNotifications1(String content, String nsid) async {
  //   try {
  //     var response = await http.post(
  //         Uri.parse('https://onesignal.com/api/v1/notifications'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'authorization':
  //               'Basic YzJiOWI0M2YtMDMwOS00NGI2LThhOTUtNmNiYWQ3Njk3YWQ2'
  //         },
  //         body: json.encode({
  //           "app_id": "64632726-24fb-4888-9337-6b26b1f894a0",
  //           "included_segments": ["Subscribed Users"],
  //           "data": {"news_id": nsid},
  //           "headings": {"ar": 'علوم الديرة', "en": 'علوم الديرة'},
  //           "contents": {"ar": content, "en": content}
  //         }));

  //     if (response.statusCode == 200) {
  //       var responsebody = jsonDecode(response.body);
  //       return responsebody;
  //     } else {
  //       // print("Error ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     return 'Error';
  //   }
  // }
}
