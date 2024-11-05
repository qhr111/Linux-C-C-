gRPC的同异步使用方式案例 C++



参考grpc中文站：[gRPC 官方文档中文版_V1.0 (oschina.net)](https://doc.oschina.net/grpc?t=61534)



## 1.同步方式



### 1.1.proto文件

```c++
// .proto文件


syntax = "proto3";
//命名空间
package IM.login;   

//定义服务
service ImLogin {
    //定义服务函数
    rpc regist (IMRegistReq) returns (IMRegistRes){}
    rpc Login (IMLoginReq) returns (IMLoginRes){}
}

//注册账号
message IMRegistReq{
    string user_name = 1; //用户名
    string password = 2; //密码
}

message IMRegistRes{
    string user_name = 1;
    uint32 user_id = 2;
    uint32 result_code = 3; //返回0则注册正常
}

//登录账号
message IMLoginReq{
    string user_name = 1; //用户名
    string password = 2; //密码
}

message IMLoginRes{
    uint32 user_id = 1;
    uint32 result_code = 2; //返回0时正确
}
```



### 1.2 server端

```c++
#include <iostream>
#include <memory>
#include <string>

#include <grpcpp/ext/proto_server_reflection_plugin.h>
#include <grpcpp/grpcpp.h>
#include <grpcpp/health_check_service_interface.h>

#include "IM.login.grpc.pb.h"

//命名空间
//grpc
using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
//自己的proto的命名空间
using IM::login::ImLogin;
using IM::login::IMRegistReq;
using IM::login::IMRegistRes;
using IM::login::IMLoginReq;
using IM::login::IMLoginRes;

class IMLoginServiceImpl: public ImLogin::Service {
    //注册
    virtual Status regist(ServerContext* context, const IMRegistReq* request,
    IMRegistRes* response) override {
        std::cout << "register user_name: " << request->user_name() << std::endl;

        response->set_user_name(request->user_name());
        response->set_user_id(10);
        response->set_result_code(0);

        return Status::OK;
    }

    //登录
    virtual Status Login(ServerContext* context, const IMLoginReq* request,
    IMLoginRes* response) override {
        std::cout << "Login user_name:" << request->user_name() << std::endl;
        response->set_user_id(10);
        response->set_result_code(0);
        return Status::OK;
    }

};

void run(){
    std::string server_address("0.0.0.0:50051");
    IMLoginServiceImpl service;
    //创建工厂类
    ServerBuilder builder;
    //监听端口和地址
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    //心跳检测
    builder.AddChannelArgument(GRPC_ARG_KEEPALIVE_TIME_MS, 5000);
    builder.AddChannelArgument(GRPC_ARG_KEEPALIVE_TIMEOUT_MS, 10000);
    builder.AddChannelArgument(GRPC_ARG_KEEPALIVE_PERMIT_WITHOUT_CALLS, 1);

    //注册服务
    builder.RegisterService(&service);

    //创建和启动一个RPC服务器
    std::unique_ptr<Server> server(builder.BuildAndStart());
    std::cout << "Server listening on " << server_address << std::endl;

    //进入服务事件循环
    server->Wait();
    }



int main(){

    run();

    return 0;
}
```



### 1.3客户端

```c++
#include <iostream>
#include <memory>
#include <string>
#include <stdint.h>
#include <grpcpp/grpcpp.h>
#include <grpcpp/health_check_service_interface.h>
#include "IM.login.grpc.pb.h"


//命名空间
//grpc
using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;

//自己的proto文件的命名空间
using IM::login::ImLogin;
using IM::login::IMRegistReq;
using IM::login::IMRegistRes;
using IM::login::IMLoginReq;
using IM::login::IMLoginRes;

class ImloginClient
{
public:
    ImloginClient(std::shared_ptr<Channel> channel)
        : stub_(ImLogin::NewStub(channel)) {}

    std::string regist(const std::string &user){
        IMRegistReq request;
        request.set_user_name(user);
        request.set_password("1234");
        IMRegistRes reply;
        ClientContext context;
        Status status = stub_->regist(&context, request, &reply);
        if(status.ok()){
            std::cout << reply.user_name() << std::endl;
            return "---successful regist---";
        }else{
            std::cout << status.error_code() << ": " << status.error_message() 
            << std::endl;
        }
    }
    std::string Login(const std::string &user){
        ClientContext context;
        IMLoginReq request;
        IMLoginRes reply;

        request.set_user_name(user);
        request.set_password("1234");
        Status status = stub_->Login(&context, request, &reply);
        if(status.ok()){
            std::cout << reply.user_id() << std::endl;
            return "---successful login ---";
        }else{
            std::cout << status.error_code() << ": " << status.error_message() 
            << std::endl;
        }
    }

private:
    std::unique_ptr<ImLogin::Stub> stub_;

};

int main(int argc, char** argv){
    std::string target_str;
    std::string arg_str("--target");
    if (argc > 1) {
        std::string arg_val = argv[1];
        size_t start_pos = arg_val.find(arg_str);
        if (start_pos != std::string::npos) {
        start_pos += arg_str.size();
        if (arg_val[start_pos] == '=') {
            target_str = arg_val.substr(start_pos + 1);
        } else {
            std::cout << "The only correct argument syntax is --target="
                    << std::endl;
            return 0;
        }
        } else {
        std::cout << "The only acceptable argument is --target=" << std::endl;
        return 0;
        }
    } else {
        target_str = "localhost:50051";
    }
    ImloginClient client(
        grpc::CreateChannel(target_str, grpc::InsecureChannelCredentials()));
        std::string user("qhr");
        std::string password("1234");
        std::string reply1 = client.regist(user);
        std::cout << "Regist received: " << reply1 << std::endl;

        std::string reply2 = client.Login(user);
        std::cout << "Login received: " << reply2 << std::endl;
    return 0;

}

```



## 2.异步方式

### 2.1 proto文件

```c++
//使用的案例为grpc/examples/cpp/rout_guide

syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.examples.routeguide";
option java_outer_classname = "RouteGuideProto";
option objc_class_prefix = "RTG";

package routeguide;

// Interface exported by the server.
service RouteGuide {
  // A simple RPC.
  //
  // Obtains the feature at a given position.
  //
  // A feature with an empty name is returned if there's no feature at the given
  // position.
  rpc GetFeature(Point) returns (Feature) {}

  // A server-to-client streaming RPC.
  //
  // Obtains the Features available within the given Rectangle.  Results are
  // streamed rather than returned at once (e.g. in a response message with a
  // repeated field), as the rectangle may cover a large area and contain a
  // huge number of features.
  rpc ListFeatures(Rectangle) returns (stream Feature) {}

  // A client-to-server streaming RPC.
  //
  // Accepts a stream of Points on a route being traversed, returning a
  // RouteSummary when traversal is completed.
  rpc RecordRoute(stream Point) returns (RouteSummary) {}

  // A Bidirectional streaming RPC.
  //
  // Accepts a stream of RouteNotes sent while a route is being traversed,
  // while receiving other RouteNotes (e.g. from other users).
  rpc RouteChat(stream RouteNote) returns (stream RouteNote) {}
}

// Points are represented as latitude-longitude pairs in the E7 representation
// (degrees multiplied by 10**7 and rounded to the nearest integer).
// Latitudes should be in the range +/- 90 degrees and longitude should be in
// the range +/- 180 degrees (inclusive).
message Point {
  int32 latitude = 1;
  int32 longitude = 2;
}

// A latitude-longitude rectangle, represented as two diagonally opposite
// points "lo" and "hi".
message Rectangle {
  // One corner of the rectangle.
  Point lo = 1;

  // The other corner of the rectangle.
  Point hi = 2;
}

// A feature names something at a given point.
//
// If a feature could not be named, the name is empty.
message Feature {
  // The name of the feature.
  string name = 1;

  // The point where the feature is detected.
  Point location = 2;
}

// A RouteNote is a message sent while at a given point.
message RouteNote {
  // The location from which the message is sent.
  Point location = 1;

  // The message to be sent.
  string message = 2;
}

// A RouteSummary is received in response to a RecordRoute rpc.
//
// It contains the number of individual points received, the number of
// detected features, and the total distance covered as the cumulative sum of
// the distance between each point.
message RouteSummary {
  // The number of points received.
  int32 point_count = 1;

  // The number of known features passed while traversing the route.
  int32 feature_count = 2;

  // The distance covered in metres.
  int32 distance = 3;

  // The duration of the traversal in seconds.
  int32 elapsed_time = 4;
}

```



### 2.2server端

```c++
#include <iostream>
#include <memory>
#include <string>
#include <thread>

#include <grpc/support/log.h>
#include <grpcpp/grpcpp.h>

#ifdef BAZEL_BUILD
#include "examples/protos/helloworld.grpc.pb.h"
#else
#include "helloworld.grpc.pb.h"
#endif

using grpc::Server;
using grpc::ServerAsyncResponseWriter;
using grpc::ServerBuilder;
using grpc::ServerCompletionQueue;
using grpc::ServerContext;
using grpc::Status;
using helloworld::Greeter;
using helloworld::HelloReply;
using helloworld::HelloRequest;

class ServerImpl final {
 public:
  ~ServerImpl() {
    server_->Shutdown();
    // Always shutdown the completion queue after the server.
    cq_->Shutdown();
  }

  // There is no shutdown handling in this code.
  void Run() {
    std::string server_address("0.0.0.0:50051");

    ServerBuilder builder;
    // Listen on the given address without any authentication mechanism.
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    // Register "service_" as the instance through which we'll communicate with
    // clients. In this case it corresponds to an *asynchronous* service.
    builder.RegisterService(&service_);
    // Get hold of the completion queue used for the asynchronous communication
    // with the gRPC runtime.
     //要在builder加入完成队列
    cq_ = builder.AddCompletionQueue();
    // Finally assemble the server.
    server_ = builder.BuildAndStart();
    std::cout << "Server listening on " << server_address << std::endl;

    // Proceed to the server's main loop.
    HandleRpcs();
  }

 private:
  // Class encompasing the state and logic needed to serve a request.
  class CallData {
   public:
    // Take in the "service" instance (in this case representing an asynchronous
    // server) and the completion queue "cq" used for asynchronous communication
    // with the gRPC runtime.
     //calldata唯一标识所请求的服务
    CallData(Greeter::AsyncService* service, ServerCompletionQueue* cq)
        : service_(service), cq_(cq), responder_(&ctx_), status_(CREATE) {
      // Invoke the serving logic right away.
      Proceed();
    }

    void Proceed() {
      if (status_ == CREATE) {
        // Make this instance progress to the PROCESS state.
        status_ = PROCESS;
          
        //只是请求系统准备接收客户端的 RPC 请求，并不进行实际的处理。
          //告诉系统本任务的唯一标识this
        service_->RequestSayHello(&ctx_, &request_, &responder_, cq_, cq_,
                                  this);
      } else if (status_ == PROCESS) {
          //这个calldata是等待下一个任务的！
        new CallData(service_, cq_);

        // The actual processing.
        std::string prefix("Hello ");
        reply_.set_message(prefix + request_.name());

        // And we are done! Let the gRPC runtime know we've finished, using the
        // memory address of this instance as the uniquely identifying tag for
        // the event.
        status_ = FINISH;
        responder_.Finish(reply_, Status::OK, this);
          //this唯一标识本任务！
      } else {
        GPR_ASSERT(status_ == FINISH);
        // Once in the FINISH state, deallocate ourselves (CallData).
        delete this;
      }
    }

   private:
    // The means of communication with the gRPC runtime for an asynchronous
    // server.
    Greeter::AsyncService* service_;
    // The producer-consumer queue where for asynchronous server notifications.
    ServerCompletionQueue* cq_;
    // Context for the rpc, allowing to tweak aspects of it such as the use
    // of compression, authentication, as well as to send metadata back to the
    // client.
    ServerContext ctx_;

    // What we get from the client.
    HelloRequest request_;
    // What we send back to the client.
    HelloReply reply_;

    // The means to get back to the client.
    ServerAsyncResponseWriter<HelloReply> responder_;

    // Let's implement a tiny state machine with the following states.
    enum CallStatus { CREATE, PROCESS, FINISH };
    CallStatus status_;  // The current serving state.
  };

  // This can be run in multiple threads if needed.
  void HandleRpcs() {
    // Spawn a new CallData instance to serve new clients.
      //启动服务器后就new一个calldata来等待任务
    new CallData(&service_, cq_.get());
    void* tag;  // uniquely identifies a request.
    bool ok;
    while (true) {
      // Block waiting to read the next event from the completion queue. The
      // event is uniquely identified by its tag, which in this case is the
      // memory address of a CallData instance.
      // The return value of Next should always be checked. This return value
      // tells us whether there is any kind of event or cq_ is shutting down.
      //当 Next 成功接收到事件时，会通过 tag 返回事件的唯一标识
      //next中会阻塞等待，直到有请求前来会返回一个calldata对象来处理
      GPR_ASSERT(cq_->Next(&tag, &ok));
      //cq_->Next() 
      //是 gRPC 异步服务器的一个核心函数，作用是阻塞等待完成队列中下一个事件的到来
      GPR_ASSERT(ok);
      //tag为指向生成的Calldata对象，执行process函数
      static_cast<CallData*>(tag)->Proceed();
    }
  }

  std::unique_ptr<ServerCompletionQueue> cq_;
  Greeter::AsyncService service_;
  std::unique_ptr<Server> server_;
};

int main(int argc, char** argv) {
  ServerImpl server;
  server.Run();

  return 0;
}

```



### 2.3client端

```c++
/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include <iostream>
#include <memory>
#include <string>

#include <grpc/support/log.h>
#include <grpcpp/grpcpp.h>

#ifdef BAZEL_BUILD
#include "examples/protos/helloworld.grpc.pb.h"
#else
#include "helloworld.grpc.pb.h"
#endif

using grpc::Channel;
using grpc::ClientAsyncResponseReader;
using grpc::ClientContext;
using grpc::CompletionQueue;
using grpc::Status;
using helloworld::Greeter;
using helloworld::HelloReply;
using helloworld::HelloRequest;

class GreeterClient {
 public:
  explicit GreeterClient(std::shared_ptr<Channel> channel)
      : stub_(Greeter::NewStub(channel)) {}

  // Assembles the client's payload, sends it and presents the response back
  // from the server.
  std::string SayHello(const std::string& user) {
    // Data we are sending to the server.
    HelloRequest request;
    request.set_name(user);

    // Container for the data we expect from the server.
    HelloReply reply;

    // Context for the client. It could be used to convey extra information to
    // the server and/or tweak certain RPC behaviors.
    ClientContext context;

    // The producer-consumer queue we use to communicate asynchronously with the
    // gRPC runtime.
    CompletionQueue cq;

    // Storage for the status of the RPC upon completion.
    Status status;

    // stub_->PrepareAsyncSayHello() creates an RPC object, returning
    // an instance to store in "call" but does not actually start the RPC
    // Because we are using the asynchronous API, we need to hold on to
    // the "call" instance in order to get updates on the ongoing RPC.
    //创建一个类型为ClientAsyncResponseReader<HelloReply>的唯一指针rpc
    std::unique_ptr<ClientAsyncResponseReader<HelloReply> > rpc(
        stub_->PrepareAsyncSayHello(&context, request, &cq));

    // StartCall initiates the RPC call
    rpc->StartCall();

    // Request that, upon completion of the RPC, "reply" be updated with the
    // server's response; "status" with the indication of whether the operation
    // was successful. Tag the request with the integer 1.
    //Finish() 的任务是告诉 gRPC，"我已经准备好接收服务器的响应，
    //请在服务器响应完成后，将数据写入 reply，并将操作状态写入 status，然后通知我。"
    rpc->Finish(&reply, &status, (void*)1);
    void* got_tag;
    //got_tag为指针类型的标记参数，用于标识具体的事件（即哪个 RPC 调用完成了）。
    //在你发起 RPC 时，比如调用 Finish() 时，传入了一个标记 (void*)1。
    //当 Next() 返回时，got_tag 将会被设置为与这个标记对应的值，这样你就能知道哪个操作完成了。
    bool ok = false;
    // Block until the next result is available in the completion queue "cq".
    // The return value of Next should always be checked. This return value
    // tells us whether there is any kind of event or the cq_ is shutting down.
    
    GPR_ASSERT(cq.Next(&got_tag, &ok));

    // Verify that the result from "cq" corresponds, by its tag, our previous
    // request.
    GPR_ASSERT(got_tag == (void*)1);
    // ... and that the request was completed successfully. Note that "ok"
    // corresponds solely to the request for updates introduced by Finish().
    GPR_ASSERT(ok);

    // Act upon the status of the actual RPC.
    if (status.ok()) {
      return reply.message();
    } else {
      return "RPC failed";
    }
  }

 private:
  // Out of the passed in Channel comes the stub, stored here, our view of the
  // server's exposed services.
  std::unique_ptr<Greeter::Stub> stub_;
};

int main(int argc, char** argv) {
  // Instantiate the client. It requires a channel, out of which the actual RPCs
  // are created. This channel models a connection to an endpoint (in this case,
  // localhost at port 50051). We indicate that the channel isn't authenticated
  // (use of InsecureChannelCredentials()).
  GreeterClient greeter(grpc::CreateChannel(
      "localhost:50051", grpc::InsecureChannelCredentials()));
  std::string user("world");
  std::string reply = greeter.SayHello(user);  // The actual RPC call!
  std::cout << "Greeter received: " << reply << std::endl;

  return 0;
}

```



## 3.CMake文件

```cmake
# **标记注释表示需修改的代码部分

cmake_minimum_required(VERSION 3.5.1)

# 1. **prohect name
project(IMLOGIN C CXX)

include(../cmake/common.cmake)

# **Proto file

get_filename_component(hw_proto "../../protos/IM.login.proto" ABSOLUTE)
get_filename_component(hw_proto_path "${hw_proto}" PATH)

# *Generated sources
set(hw_proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/IM.login.pb.cc")
set(hw_proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/IM.login.pb.h")
set(hw_grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/IM.login.grpc.pb.cc")
set(hw_grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/IM.login.grpc.pb.h")
add_custom_command(
      OUTPUT "${hw_proto_srcs}" "${hw_proto_hdrs}" "${hw_grpc_srcs}" "${hw_grpc_hdrs}"
      COMMAND ${_PROTOBUF_PROTOC}
      ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${hw_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${hw_proto}"
      DEPENDS "${hw_proto}")

# Include generated *.pb.h files
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

# hw_grpc_proto
add_library(hw_grpc_proto
  ${hw_grpc_srcs}
  ${hw_grpc_hdrs}
  ${hw_proto_srcs}
  ${hw_proto_hdrs})
target_link_libraries(hw_grpc_proto
  ${_REFLECTION}
  ${_GRPC_GRPCPP}
  ${_PROTOBUF_LIBPROTOBUF})

# **Targets greeter_[async_](client|server)
foreach(_target
  # greeter_client 
  IMLogin_server 
  IMLogin_client
  # greeter_callback_client greeter_callback_server 
  # greeter_async_client greeter_async_client2 greeter_async_server)
)
  add_executable(${_target} "${_target}.cc")
  target_link_libraries(${_target}
    hw_grpc_proto
    ${_REFLECTION}
    ${_GRPC_GRPCPP}
    ${_PROTOBUF_LIBPROTOBUF})
endforeach()

```

