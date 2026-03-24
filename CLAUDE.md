# Vue 3 + DevExtreme — Project Rules

## Stack
- Framework: Vue 3 Composition API (`<script setup lang="ts">`)
- UI: DevExtreme Vue — always prefer DX components over native HTML
- State: Pinia (business) · TanStack Query (server) · local ref (UI)
- Language: TypeScript

## DevExtreme MCP
If a DevExtreme MCP server is connected, ALWAYS consult it before generating
component APIs, event names, or config options. Never guess DX API.

## Active Rules
@.claude/rules/vue3-devextreme/dx-components.md
@.claude/rules/vue3-devextreme/state-and-data.md
@.claude/rules/vue3-devextreme/performance.md
@.claude/rules/vue3-devextreme/code-quality.md

## Invoke skill for new screens
To generate a complete enterprise screen (Toolbar + Grid + CRUD popup):
/vue3-devextreme
