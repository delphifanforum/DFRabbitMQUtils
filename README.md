# DFRabbitMQUtils
DFRabbitMQUtils is a minimalistic utility unit for interacting with RabbitMQ in Delphi applications. This unit provides basic functions to perform common RabbitMQ operations using the AMQP protocol. Please note that this unit is intended as a starting point for simple RabbitMQ interactions and does not cover all the complexities of the AMQP protocol.

# Features
DFRabbitMQUtils includes the following functions:

Declare a queue
Publish a message
Declare an exchange
Bind a queue to an exchange
Consume messages from a queue
Get the approximate message count in a queue

# Usage
1. Download the DFRabbitMQUtils.pas file from this repository.

2. Add the DFRabbitMQUtils.pas unit to your Delphi project.

3. In your project, use the functions provided by the DFRabbitMQUtils unit to interact with RabbitMQ. Here's an example of how to use some of the functions:

```delphi
uses
  SysUtils, DFRabbitMQUtils;

var
  Host, QueueName, ExchangeName, RoutingKey, MsgBody: string;
  MessageCount: Integer;

begin
  Host := 'localhost';  // RabbitMQ server hostname or IP

  // Declare a queue
  QueueName := 'my_queue';
  DeclareQueue(Host, QueueName);

  // Publish a message
  ExchangeName := 'my_exchange';
  RoutingKey := 'routing_key';
  MsgBody := 'Hello, RabbitMQ!';
  PublishMessage(Host, ExchangeName, RoutingKey, MsgBody);

  // Declare an exchange
  ExchangeName := 'my_exchange';
  DeclareExchange(Host, ExchangeName, 'direct');

  // Bind a queue to an exchange
  BindQueue(Host, QueueName, ExchangeName, RoutingKey);

  // Consume messages from a queue
  ConsumeQueue(Host, QueueName,
    procedure(Message: string)
    begin
      Writeln('Received: ' + Message);
    end);

  // Get the approximate message count in a queue
  MessageCount := GetQueueMessageCount(Host, QueueName);
  Writeln('Message count in queue: ' + IntToStr(MessageCount));

  Readln;
end.
```

Please note that this utility is a basic starting point and may require further customization and error handling for production use. For more advanced and feature-rich solutions, consider using established RabbitMQ client libraries.
