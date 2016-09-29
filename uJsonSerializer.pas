unit uJsonSerializer;

interface

uses sysutils, classes, generics.collections;

type
  TJsonSerializator = class
  public
    class function Serialize<T>(const obj: T): String;
    class function Deserialize<T>(const Json: string): T;
  end;

implementation

uses superobject;

{ TJsonSerializator }

class function TJsonSerializator.Deserialize<T>(const Json: string): T;
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

class function TJsonSerializator.Serialize<T>(const obj: T): String;
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

end.
