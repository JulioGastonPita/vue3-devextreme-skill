---
name: vue3-devextreme
description: >
  Genera pantallas enterprise completas con Vue 3, DevExtreme Vue, Pinia y
  TanStack Query. Inspecciona la base de datos conectada para inferir campos,
  tipos y relaciones automáticamente. Usar cuando se necesite crear una
  pantalla CRUD nueva para cualquier entidad del sistema.
agent: claude-code
---

# vue3-devextreme

Generate a complete enterprise screen following the project stack:
Vue 3 + DevExtreme Vue + Pinia + TanStack Query + TypeScript.

---

## Step 1 — Gather context (ALWAYS before generating)

Ask the user:

> "¿Qué entidad/recurso vamos a gestionar? (ej: Productos, Usuarios, Pedidos)
> Dame el nombre y, si hay una tabla en la BD, la inspecciono yo."

Wait for the answer. Then execute Step 2.

---

## Step 2 — Inspect the database (if a DB connection is available)

Check if an MCP database tool is connected (PostgreSQL, MySQL, SQL Server, SQLite, etc.).

### If DB is connected — run this inspection sequence:

**2a. Get column schema**
```sql
SELECT
  column_name,
  data_type,
  is_nullable,
  column_default,
  character_maximum_length
FROM information_schema.columns
WHERE table_name = '<tabla>'
ORDER BY ordinal_position;
```

**2b. Get foreign keys**
```sql
SELECT
  kcu.column_name        AS fk_column,
  ccu.table_name         AS ref_table,
  ccu.column_name        AS ref_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = '<tabla>';
```

**2c. Fetch lookup data for each FK found**
For each foreign key column found, run:
```sql
SELECT id, name FROM <ref_table> LIMIT 100;
-- adapt column names if the referenced table uses different naming
```

**2d. Infer from results:**

| DB type | DX editor | DX format | Notes |
|---------|-----------|-----------|-------|
| int / bigint | dxNumberBox | — | PK → hidden column |
| varchar / text | dxTextBox | — | NOT NULL → DxRequiredRule |
| decimal / numeric | dxNumberBox | currency or fixedPoint | |
| boolean / tinyint(1) | dxCheckBox | — | |
| date | dxDateBox | dd/MM/yyyy | |
| datetime / timestamp | dxDateBox | dd/MM/yyyy HH:mm | |
| int FK | dxSelectBox | — | use lookup data from 2c |
| email (name hint) | dxTextBox mode:email | — | add DxEmailRule |
| phone / telefono | dxTextBox | — | |
| activo / active | dxCheckBox | — | |

### If NO DB is connected:

Ask the user:
> "No detecto una conexión de base de datos activa.
> Por favor indicame los campos de la entidad con su tipo:
> (ej: nombre: texto requerido, precio: decimal, categoriaId: FK a categorias)"

---

## Step 3 — Confirm schema before generating

Show a markdown table: `campo | tipo DB | editor DX | reglas inferidas`
Include every column. Mark PK as oculto, mark createdAt/updatedAt as solo lectura.

Then ask:
> "¿El esquema es correcto? ¿Hay campos que excluir del form o de la grilla?
> Confirmá con 'sí' o indicá los ajustes."

Wait for confirmation. Then execute Step 4.

---

## Step 4 — Generate the 4 files

Generate in this exact order:

### File 1: `src/services/<entity>Api.ts`
- TypeScript interface derived from DB schema (exclude createdAt/updatedAt from Partial)
- getAll(loadOptions: LoadOptions) → Promise<{ data: Entity[], totalCount: number }>
- create(payload: Partial<Entity>) → Promise<Entity>
- update(id: number, payload: Partial<Entity>) → Promise<Entity>
- delete(id: number) → Promise<void>
- Use axios with typed responses
- Export both the interface and the api object

### File 2: `src/queries/use<Entity>.ts`
- useQuery for GET  (queryKey: ['<entity>'])
- useMutation for POST / PUT / DELETE
- invalidateQueries on success
- notify('...', 'success', 2000) on success
- notify('...', 'error', 3000) on error

### File 3: `src/composables/use<Entity>Grid.ts`
- useGridStore wrapping the service
- formData as reactive<Partial<Entity>>({})
- popupVisible ref
- isEditMode ref (true when editing, false when adding)
- openAdd()  → resets formData, sets isEditMode false, opens popup
- openEdit(row) → copies row to formData, sets isEditMode true, opens popup
- handleSaved() → calls invalidateQueries, closes popup

### File 4: `src/views/<Entity>View.vue`
- DxLoadPanel bound to isLoading from useQuery
- DxToolbar with entity title + "Nuevo" DxButton
- DxDataGrid:
  - :remote-operations="true"
  - :repaint-changes-only="true"
  - :show-borders="true"
  - :column-auto-width="true"
  - :row-alternation-enabled="true"
  - DxEditing mode="popup" allow-adding allow-updating allow-deleting
  - DxFilterRow, DxHeaderFilter, DxSearchPanel
  - DxPaging page-size=15 + DxPager with selector
  - DxExport enabled
  - DxColumn for each non-hidden field with correct data-type and format
  - DxLookup on FK columns using lookup data fetched in Step 2c
  - DxSummary / DxTotalItem on numeric columns if relevant
- DxPopup v-model:visible with DxForm:
  - label-mode="floating"
  - :col-count="2"
  - DxSimpleItem per field with correct editor-type and editorOptions as const
  - DxRequiredRule on NOT NULL fields
  - DxEmailRule on email fields
  - DxStringLengthRule matching DB character_maximum_length
  - DxSelectBox with dataSource for FK fields
  - createdAt / updatedAt → excluded from form
- All DX imports individual (tree-shaking)
- All editorOptions defined as const outside template

---

## Rules to follow while generating

- Consult DevExtreme MCP for any DX API option before writing it
- Never use native HTML when a DX equivalent exists
- v-model:visible on DxPopup — never :visible + @update:visible
- DxSimpleItem (not DxItem) for form fields
- locale already configured in main.ts — do not re-import
- TypeScript event types on all handlers (RowInsertedEvent, etc.)
- No raw fetch inside components — all API calls via service layer

---

## Step 5 — Post-generation checklist

After all 4 files are generated, show:

```
✅ Archivos generados:
   src/services/<entity>Api.ts
   src/queries/use<Entity>.ts
   src/composables/use<Entity>Grid.ts
   src/views/<Entity>View.vue

📋 Pasos pendientes:
   [ ] Agregar ruta en router/index.ts
   [ ] Registrar en el menú de navegación
   [ ] Verificar URL base del endpoint en <entity>Api.ts
   [ ] Verificar que los lookups de FK devuelvan id y name correctos
   [ ] Ajustar columnas visibles en DxDataGrid si es necesario
   [ ] Ajustar campos del DxForm si es necesario
```
