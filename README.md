# BufEdit

## What is it?

This is a tiny vim plugin to help manage your buffers. Basically when I'm exploring a big project
for the first time or trying to track down where I particular piece of logic lives, I find I tend to
open a ton of new buffers really quickly, and once I've found whatever I was looking for those
buffers tend to just get in the way. Deleting them all using `:buffers` and `:bw` is a giant PITA,
so this is designed to make that a little bit easier.

## Installation

Install this in the same way you would install any vim plugin. If you don't already have a preferred
method, I recommend tpope's [pathogen](https://github.com/tpope/vim-pathogen).

## Usage

BufEdit adds a single command `:BufEdit`, which opens a special `**Buffer-List**` buffer containing
a list of all the other open buffers. To wipe a buffer, simply delete it from the `**Buffer-List**`
and save it.
