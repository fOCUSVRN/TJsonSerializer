unit uJsonSerializer;

interface

uses sysutils, classes, generics.collections;

type
  TJsonSerializer = class
  public
    class function Serialize<T>(const obj: T): String;
    class function Deserialize<T>(const Json: string): T;
  end;

implementation

uses superobject;

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

end.
