# BufEdit

## What is it?

This is a tiny vim plugin to help manage your buffers. First, when I'm exploring a big project
for the first time or trying to track down where I particular piece of logic lives, I find I tend to
open a ton of new buffers really quickly, and once I've found whatever I was looking for those
buffers tend to just get in the way. Deleting them all using `:buffers` and `:bw` is a giant PITA.

Second, sometime when I try to close vim with `:qa`, it fails because there are buffers with
unsaved changes. Sometimes, there are several files with unsaved changes. When that happens,
tracking them all down and saving / force closing them all is another PITA.

This plugin exists to make those two things easier.

## Installation

Install this in the same way you would install any vim plugin. If you don't already have a preferred
method, I recommend tpope's [pathogen](https://github.com/tpope/vim-pathogen).

## Usage

BufEdit adds two commands `:BufEdit` and `:BufUnsaved`

* **`:BufEdit`** wipes all buffers that have never been used (i.e. there's no name and no unsaved
  changes) and then opens a special `**Buffer-List**` buffer containing a list of all the other open
  buffers. To wipe a buffer, simply delete it from the `**Buffer-List**` and save it.
* **`:BufUnsaved`** finds all the buffers that contain unsaved changes, and loads them all into the
  quickfix list (see `:help quickfix`). You can then iterate through these buffers with `:cprev` and
  `cnext`.
