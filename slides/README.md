## Slides
Slides are written with [Marpit Markdown](https://marpit.marp.app). Changes can be compiled to html with the [Marp CLI](https://github.com/marp-team/marp-cli#try-it-now).

On Nix-systems (x86_64-linux):
```
nix-shell -p marp --command 'marp slides.md'
```
Or with npm exec:
```
npx @marp-team/marp-cli@latest slides.md
```
