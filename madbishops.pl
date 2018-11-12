:- consult('display.pl').
:- consult('menu.pl').
:- consult('logic.pl').
:- use_module(library(lists)).
:- use_module(library(between)).

play:-mainMenu,
    start.