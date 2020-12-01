#r "paket:
nuget Fake.DotNet.Cli
nuget Fake.IO.FileSystem
nuget Fake.Core.Target 
nuget Fake.JavaScript.Yarn //"
#load ".fake/build.fsx/intellisense.fsx"
open System
open System.Text
open Fake.Core
open Fake.DotNet
open Fake.IO
open Fake.IO.FileSystemOperators
open Fake.IO.Globbing.Operators
open Fake.Core.TargetOperators
open Fake.JavaScript

let getProcessError: ProcessResult -> ConsoleMessage list =
  fun x -> x.Results
  >> List.filter (fun x -> x.IsError)

let processErrorToText: ConsoleMessage list -> string = 
  List.map (fun x -> x.Message)
  >> List.fold (fun (acc: StringBuilder) (x: string) -> acc.Append(x + ",\n")) (StringBuilder())
  >> fun x -> x.ToString()

let exec command arg path = 
  DotNet.exec (fun opt -> { opt with WorkingDirectory = path }) command arg 
  |> getProcessError 
  |> function 
  | [] -> () 
  | errs -> 
    processErrorToText errs 
    |> failwith

Target.initEnvironment ()

Target.create "Clean" (fun _ ->
  exec "fornax clean" "" "blog"  
)

Target.create "Build" (fun _ ->
  exec "fornax build" "" "blog"
)

Target.create "Watch" (fun _ ->
  exec "fornax watch" "" "blog"
)

Target.create "YarnInstall" (fun _ ->
  Yarn.install id
)

Target.create "All" ignore

"Clean"
  ==> "All"

Target.runOrDefault "All"
