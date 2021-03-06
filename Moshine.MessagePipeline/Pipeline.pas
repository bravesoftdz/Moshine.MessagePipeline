﻿namespace Moshine.MessagePipeline;

uses
  System.Collections.Generic,
  System.Data,
  System.IO,
  System.Linq,
  System.Linq.Expressions,
  System.Reflection,
  System.Runtime.CompilerServices,
  System.Runtime.Serialization,
  System.Text,
  System.Threading,
  System.Threading.Tasks,
  System.Threading.Tasks.Dataflow,
  System.Transactions,
  System.Xml,
  System.Xml.Serialization,
  Moshine.MessagePipeline.Cache,
  Moshine.MessagePipeline.Core,
  Newtonsoft.Json;

type

  Pipeline = public class(IPipeline)
  const
    workSubscription = 'work';
    errorSubscription = 'error';

  private
    _maxRetries:Integer;
    tokenSource:CancellationTokenSource;
    token:CancellationToken;
    processMessage:TransformBlock<MessageParcel, MessageParcel>;
    finishProcessing:ActionBlock<MessageParcel>;
    faultedInProcessing:ActionBlock<MessageParcel>;
    t:Task;

    _cache:ICache;
    _bus:IBus;

    _methodCallHelpers:MethodCallHelpers := new MethodCallHelpers;
    _actionInvokerHelpers:ActionInvokerHelpers := new ActionInvokerHelpers;


    method Initialize;
    begin
      _bus.Initialize;
    end;

    method Load(someAction:SavedAction);
    begin
      HandleTrace('Invoking action');

      var returnValue := _actionInvokerHelpers.InvokeAction(someAction);

      if(assigned(returnValue))then
      begin
        _cache.Add(someAction.Id.ToString,returnValue);

      end;

    end;

    method EnQueue(someAction:SavedAction);
    begin
      var stringRepresentation := PipelineSerializer.Serialize(someAction);

      _bus.Send(stringRepresentation, someAction.Id.ToString);

    end;

    method HandleTrace(message:String);
    begin
      if(assigned(self.TraceCallback))then
      begin
        self.TraceCallback(message);
      end;
    end;


    method HandleException(e:Exception);
    begin
      if(assigned(self.ErrorCallback))then
      begin
        self.ErrorCallback(e);
      end;
    end;

    method Setup;
    begin
      processMessage := new TransformBlock<MessageParcel, MessageParcel>(parcel ->
          begin
            try
              HandleTrace('ProcessMessage');

              var body := parcel.Message.GetBody;
              var savedAction := PipelineSerializer.Deserialize<SavedAction>(body);
              using scope := new TransactionScope(TransactionScopeOption.RequiresNew) do
              begin
                HandleTrace('LoadAction');
                Load(savedAction);
                scope.Complete;
              end;
              parcel.State := MessageStateEnum.Processed;
            except
              on E:Exception do
              begin
                HandleException(E);
                parcel.State := MessageStateEnum.Faulted;
                parcel.ReTryCount := parcel.ReTryCount+1;
              end;
            end;
            exit parcel;
          end,
          new ExecutionDataflowBlockOptions(MaxDegreeOfParallelism := 5)
          );

      faultedInProcessing := new ActionBlock<MessageParcel>(parcel ->
          begin
            HandleTrace('Fault in processing');
            try

              using scope := new TransactionScope() do
              begin

                _bus.CannotBeProcessed(parcel.Message);

                scope.Complete;
              end;

            except
              on e:Exception do
              begin
                HandleException(e);
                raise;
              end;
            end;
          end);

      finishProcessing := new ActionBlock<MessageParcel>(parcel ->
          begin
            HandleTrace('Finished processing');
            try
              parcel.Message.Complete;
            except
              on e:Exception do
              begin
                HandleException(e);
                raise;
              end;
            end;
          end);

      processMessage.LinkTo(finishProcessing, p -> p.State = MessageStateEnum.Processed);
      processMessage.LinkTo(processMessage, p -> (p.State = MessageStateEnum.Faulted) and (p.ReTryCount < self._maxRetries));
      processMessage.LinkTo(faultedInProcessing, p -> (p.State = MessageStateEnum.Faulted) and (p.ReTryCount >= self._maxRetries));

    end;



  public

    constructor(cache:ICache;bus:IBus);
    begin
      _maxRetries := 4;
      _cache:=cache;
      _bus:= bus;

      Initialize;

      tokenSource := new CancellationTokenSource();
      token := tokenSource.Token;

      Setup;
    end;

    method Stop;
    begin
      tokenSource.Cancel();

      processMessage.Complete();
      finishProcessing.Completion.Wait();

      Task.WaitAll(t);

    end;

    method Start;
    begin
      HandleTrace('Start');

      t := Task.Factory.StartNew( () ->
        begin
          try

            repeat
              var serverWaitTime := new TimeSpan(0,0,2);

              var someMessage:=_bus.Receive(serverWaitTime);

              if(assigned(someMessage))then
              begin
                HandleTrace('Posting message');
                var parcel := new MessageParcel(Message := someMessage);
                processMessage.Post(parcel);
              end;

            until token.IsCancellationRequested;
          except
            on e:Exception do
            begin
              HandleException(e);
              raise;
            end;
          end;
        end, token);

    end;

    method Send<T>(methodCall: Expression<Func<T,Boolean>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,Double>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,Integer>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,LongWord>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,ShortInt>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,Single>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,SmallInt>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<Func<T,Word>>): Response;
    begin
    end;

    method Send<T>(methodCall: Expression<System.Action<T>>):Response;
    begin
      if(assigned(methodCall))then
      begin
        var saved := _methodCallHelpers.Save(methodCall);
        EnQueue(saved);
        exit new Response(Id:=saved.Id);
      end;
    end;

    method Send<T>(methodCall: Expression<System.Func<T,Object>>):Response;
    begin
      if(assigned(methodCall))then
      begin
        var saved := _methodCallHelpers.Save(methodCall);
        EnQueue(saved);
        exit new Response(Id:=saved.Id);
      end;

    end;


    property ErrorCallback:Action<Exception>;
    property TraceCallback:Action<String>;

  end;

end.