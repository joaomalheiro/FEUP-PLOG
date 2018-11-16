:- consult('display.pl').
:- consult('menu.pl').
:- consult('logic.pl').
:- use_module(library(lists)).
:- use_module(library(between)).
:- use_module(library(random)).
:- use_module(library(system)).

play:-mainMenu.

%consult('madbishops.pl').