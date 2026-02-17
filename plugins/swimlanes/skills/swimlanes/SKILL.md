---
name: swimlanes
description: Generate sequence diagrams using Swimlanes.io syntax
version: 1.0.0
---

# Swimlanes Sequence Diagram Generator

Generate a sequence diagram for: $ARGUMENTS

## Output Requirements

1. Output valid Swimlanes.io syntax in a code block
2. Remind the user to paste at https://swimlanes.io/ to render
3. After showing the diagram, use the AskUserQuestion tool to ask if they want to copy it to their clipboard (Yes/No options). If yes, use `pbcopy` (macOS) or `xclip` (Linux) to copy the diagram code (without the markdown code fence)

## Swimlanes.io Syntax Reference

### Messages
```
One -> Two: Simple message
Two ->> Three: Open arrow
Three -x Four: Lost message
Three <-> Four: Bi-directional
Two -> Two: To self (loop)
Two <- One: Reverse direction
Two --> Three: Dashed line
Two => Three: Bold line
```

### Notes
```
note: Simple note (spans previous message width)
note One, Three: Note spanning from One to Three actor
```
Notes support markdown: **bold**, *italic*, ~~strikethrough~~, `inline code`, lists, links, and code blocks.

### Sections (Conditionals/Grouping)
```
if: Condition label
  Two -> Three: Message in condition
else: Alternative label
  Two -> One: Alternative message
end

group: Group label
  One -> Two: Grouped messages
end
```
Sections can be nested one level.

### Dividers
```
_: thin divider (or section label)
-: regular divider
--: dashed divider
=: bold divider
```
Dividers support markdown formatting.

### Other Features
```
title: Diagram Title
autonumber
...: Delay indicator
order: Three, Two, One
```

### Icons
Font Awesome icons: `{fa$-icon}` where $ is: b (brand), s (solid), r (regular), l (light), d (duotone)
