// codeunit 90107 "Uri Builder TPTE"
// {
//     Access = Internal;

//     var
//         QueryKeys: Dictionary of [Text, Text];
//         AbsoluteUri: Text;
//         CurrentPath: Text;
//         CurrentUri: Text;
//         QueryString: Text;

//     procedure Init(Uri: Text)
//     begin
//         CurrentUri := Uri;
//     end;

//     procedure SetPath(Path: Text)
//     begin
//         CurrentPath := Path;
//     end;

//     procedure GetAbsoluteUri(): Text
//     begin
//         BuildUri();
//         exit(AbsoluteUri);
//     end;

//     procedure AddQueryParameter(ParameterKey: Text; ParameterValue: Text)
//     // var
//     //     UriBuilder: Codeunit "Uri Builder";
//     begin
//         // uribuilder.AddQueryParameter('key', 'value
//         QueryKeys.Add(ParameterKey, ParameterValue);
//     end;

//     local procedure BuildUri()
//     begin
//         BuildQueryString();
//         AbsoluteUri := CurrentUri + CurrentPath + QueryString; //TODO Fix /
//     end;

//     local procedure BuildQueryString()
//     var
//         QueryParamTok: Label '&%1=%2', Comment = '%1=key, %2=value', Locked = true;
//         QueryKey: Text;
//     begin
//         QueryString := '';
//         foreach QueryKey in QueryKeys.Keys() do
//             QueryString += StrSubstNo(QueryParamTok, QueryKey, QueryKeys.Get(QueryKey));

//         QueryString := DelChr(QueryString, '<', '&');
//         if QueryString <> '' then
//             QueryString := '?' + QueryString;
//     end;
// }