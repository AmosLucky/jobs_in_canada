import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';



class JobPage extends StatefulWidget {
  String job_link;
  JobPage({super.key, required this.job_link});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  WebViewController? _controller;
  @override
  void initState() {
    print( widget.job_link);
    if (!widget.job_link.startsWith("http")) {
      widget.job_link = "http://" + widget.job_link;
      setState(() {});
       print( widget.job_link);
    }
    // TODO: implement initState
    super.initState();
  }

  int progress = 0;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MColors.primaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          progress < 100
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
          Container(
            child: WebView(
              initialUrl: widget.job_link,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
              onPageStarted: (String url) {
                // print("Pages started");
                // print(url);
              },
              onWebResourceError: (error) {
                print(error);
              },
              onProgress: (_progress) {
                //progress = _progress;
                setState(() {});
                print(_progress);
              },
            ),
          ),
        ],
      ),
    );
  }
}
