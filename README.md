Intranet V2

# Description

A modular webapp that handles business accounting (supplier/client invoices, cash transactions and employees compensation).
It links all business transaction to a PDF document.
Reports all the costs/revenues/profits in a single interactive table that can be drilled-down to explore costs / revenue sources.

# Modules

Each module is expected to have several subfolders:
1. 01_tables - one or several sql files with code to create each table necessary for this module, or tables exposed to other modules
2. 02_functions - lists functions that simplify access to data
3. 03_views - one or several sql files with a pre-written select query
4. 04_storedProcedures - one or several sql files with user-callable functions to insert/update/delete data
5. 05_tests - one or several _php_ fluent API files, that lists tests necessary to guaratee functions perform as expected





This is a simple new test string.
