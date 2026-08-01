## 9. DRY, The Evils of Duplication

Software development is continuous maintenance because requirements, regulations, environments, algorithms, and understanding keep changing. The Don't Repeat Yourself (DRY) principle makes change reliable by giving every piece of knowledge or intent one unambiguous, authoritative representation; when the same knowledge appears in multiple places or formats, missed updates create contradictions. DRY applies to specifications, processes, code, documentation, data, interfaces, and team practices, but identical code is not necessarily duplicated knowledge when it expresses independent rules that merely coincide. Centralize shared behavior and presentation, let clear names and structure convey what code already says, and calculate derived data from its source unless performance requires a cache whose synchronization stays encapsulated behind uniform accessors. Reduce unavoidable duplication at system boundaries by generating clients, tests, documentation, and data containers from neutral application programming interface (API) specifications or introspected schemas, or by validating flexible key/value data against explicit requirements. Prevent developers from independently recreating functionality through frequent communication, shared repositories, code review, knowledge stewardship, and reuse that is easier than reimplementation.

### The Pragmatic Approach

- Give each piece of knowledge or intent one authoritative representation.
- Change a rule in one place, and treat changes required in multiple places or formats as evidence of duplicated knowledge.
- Distinguish shared knowledge from coincidentally identical code before extracting an abstraction.
- Replace repeated logic and presentation rules with named functions or other single points of change.
- Use clear names and readable structure instead of comments that restate implementation details.
- Compute derived values from their source data; when caching is necessary, encapsulate the cache and keep it synchronized through accessors.
- Generate integrations and data representations from formal specifications or schemas whenever possible.
- Validate flexible external data against a table of required fields and formats.
- Communicate frequently, review colleagues' work, centralize reusable utilities, and make existing functionality easy to find and reuse.
