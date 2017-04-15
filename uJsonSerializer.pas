unit uJsonSerializer;

interface

uses sysutils, classes, generics.collections;

// чтобы работать с атрибутами, нужно в модуле, где описывается модель добавить в uses superobject

// юзать так:
// [SOName('jsonfieldname')]]

type
  TJsonSerializer = class
  public
    class function Serialize<T>(const obj: T): String;
    class function Deserialize<T>(const Json: string): T;
  end;

  TClassCloner = class
    class function Clone(aValue: TObject): TObject; overload;
    class function Clone<T: class>(aValue: TObject): T; overload;
  end;

  TXMLSerializer = class
  public
    class function Deserialize<T>(const XML: string): T;
  end;

implementation

uses superobject, dbxjsonreflect, Json, rtti, typinfo, controls, superxmlparser;

{ TJsonSerializer }

class function TJsonSerializer.Deserialize<T>(const Json: string): T;
var
  ctx: TSuperRttiContext;
begin
  ctx := TSuperRttiContext.Create;
  try
    result := ctx.AsType<T>(SO(Json));
  finally
    freeandnil(ctx);
  end;
end;

class function TJsonSerializer.Serialize<T>(const obj: T): String;
var
  ctx: TSuperRttiContext;
begin
  ctx := TSuperRttiContext.Create;
  try
    result := ctx.AsJson(obj).AsJson(true, false);
  finally
    freeandnil(ctx);
  end;
end;

{ TClassCloner }

class function TClassCloner.Clone(aValue: TObject): TObject;
var
  MarshalObj: TJSONMarshal;
  UnMarshalObj: TJSONUnMarshal;
  JSONValue: TJSONValue;
begin
  result := nil;
  MarshalObj := TJSONMarshal.Create;
  UnMarshalObj := TJSONUnMarshal.Create;
  try
    JSONValue := MarshalObj.Marshal(aValue);
    try
      if Assigned(JSONValue) then
        result := UnMarshalObj.Unmarshal(JSONValue);
    finally
      JSONValue.Free;
    end;
  finally
    MarshalObj.Free;
    UnMarshalObj.Free;
  end;
end;

class function TClassCloner.Clone<T>(aValue: TObject): T;
begin
  result := Clone(aValue) as T;
end;

{ TXMlDeserializer }

class function TXMLSerializer.Deserialize<T>(const XML: string): T;
var
  ctx: TSuperRttiContext;
begin
  ctx := TSuperRttiContext.Create;
  try
    result := ctx.AsType<T>(XMLParseString(XML, true));
  finally
    freeandnil(ctx);
  end;
end;

end.
