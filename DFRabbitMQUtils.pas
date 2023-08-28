unit DFRabbitMQUtils;

interface

procedure DeclareQueue(const Host, QueueName: string; Port: Integer = 5672);
procedure PublishMessage(const Host, ExchangeName, RoutingKey, MsgBody: string; Port: Integer = 5672);
procedure DeclareExchange(const Host, ExchangeName, ExchangeType: string; Port: Integer = 5672);
procedure BindQueue(const Host, QueueName, ExchangeName, RoutingKey: string; Port: Integer = 5672);
procedure ConsumeQueue(const Host, QueueName: string; OnReceive: TProc<string>; Port: Integer = 5672);
function GetQueueMessageCount(const Host, QueueName: string; Port: Integer = 5672): Integer;

implementation

uses
  IdTCPClient, SysUtils;

procedure SendCommand(const Client: TIdTCPClient; const Command: string);
begin
  Client.IOHandler.WriteLn(Command);
end;

function ReceiveResponse(const Client: TIdTCPClient): string;
begin
  Result := Client.IOHandler.ReadLn;
end;

procedure DeclareQueue(const Host, QueueName: string; Port: Integer);
var
  Client: TIdTCPClient;
begin
  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'DECLARE_QUEUE ' + QueueName);
    ReceiveResponse(Client);
  finally
    Client.Free;
  end;
end;

procedure PublishMessage(const Host, ExchangeName, RoutingKey, MsgBody: string; Port: Integer);
var
  Client: TIdTCPClient;
begin
  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'PUBLISH ' + ExchangeName + ' ' + RoutingKey);
    SendCommand(Client, MsgBody);
    ReceiveResponse(Client);
  finally
    Client.Free;
  end;
end;

procedure DeclareExchange(const Host, ExchangeName, ExchangeType: string; Port: Integer);
var
  Client: TIdTCPClient;
begin
  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'DECLARE_EXCHANGE ' + ExchangeName + ' ' + ExchangeType);
    ReceiveResponse(Client);
  finally
    Client.Free;
  end;
end;

procedure BindQueue(const Host, QueueName, ExchangeName, RoutingKey: string; Port: Integer);
var
  Client: TIdTCPClient;
begin
  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'BIND_QUEUE ' + QueueName + ' ' + ExchangeName + ' ' + RoutingKey);
    ReceiveResponse(Client);
  finally
    Client.Free;
  end;
end;

procedure ConsumeQueue(const Host, QueueName: string; OnReceive: TProc<string>; Port: Integer);
var
  Client: TIdTCPClient;
  Response: string;
begin
  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'CONSUME ' + QueueName);
    repeat
      Response := ReceiveResponse(Client);
      if Response <> 'END_CONSUME' then
        OnReceive(Response);
    until Response = 'END_CONSUME';
  finally
    Client.Free;
  end;
end;

function GetQueueMessageCount(const Host, QueueName: string; Port: Integer): Integer;
var
  Client: TIdTCPClient;
begin
  Result := -1; // Default value in case of errors

  Client := TIdTCPClient.Create(nil);
  try
    Client.Host := Host;
    Client.Port := Port;
    Client.Connect;
    
    SendCommand(Client, 'GET_QUEUE_MESSAGE_COUNT ' + QueueName);
    Result := StrToIntDef(ReceiveResponse(Client), -1);
  finally
    Client.Free;
  end;
end;

end.