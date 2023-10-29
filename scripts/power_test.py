# \source "E:\Documents\BDMA\ULB\Data Warehouses\project1\DSGen-software-code-3.2.0rc1\TPC-DS-MySQL\scripts\power_test.py"

import argparse
import os
import re
import time
from datetime import datetime

import matplotlib.pyplot as plt
import mysql.connector
import pandas as pd
import seaborn as sns

from scripts.utils import extract_number

# from mysqlsh import mysql

# session = mysql.get_classic_session("mysql://root:password@localhost:3306")

# base_dir = "E:/Documents/BDMA/ULB/Data Warehouses/project1/DSGen-software-code-3.2.0rc1/TPC-DS-MySQL"
# os.chdir(base_dir)


def read_sql_files(directory):
    queries = {}
    for filename in sorted(os.listdir(directory), key=extract_number):
        if filename.endswith(".sql"):
            with open(os.path.join(directory, filename), "r") as f:
                sql_content = f.read()
                sql_content = re.sub(r"--.*$", "", sql_content, flags=re.MULTILINE)
                sql_content = " ".join(sql_content.split())
                # only capture query number
                queries[extract_number(filename)] = sql_content
    return queries


# Function to execute queries and measure time
def execute_queries(queries, cursor) -> dict:
    query_times = {}
    for filename, query in queries.items():
        print("Executing", filename, end="...\n")
        total_time = 0
        query_lst = query.strip().split(";")
        query_lst = list(filter(lambda x: len(x.strip()) > 0, query_lst))
        for q in query_lst:
            q = q.strip()
            # warm up the cache
            print("executing warmup query")
            start_time = time.time()
            cursor.execute(query)
            cursor.fetchall()
            while cursor.nextset():
                pass
            print(
                "executed warmup query. took",
                time.time() - start_time,
                "seconds",
            )
            start_time = time.time()
            # session.run_sql(q)
            cursor.execute(query)
            cursor.fetchall()
            while cursor.nextset():
                pass
            end_time = time.time()
            elapsed_time = end_time - start_time
            total_time += elapsed_time
        print(f"{filename} took {total_time} seconds")
        query_times[filename] = total_time
    return query_times


# Function to save results to a file
def save_results_to_file(query_times, scale_factor, uid):
    filename = f"results\\power_test_sf={scale_factor}_{uid}.txt"
    with open(filename, "w") as f:
        for time in query_times.values():
            f.write(f"{time}\n")
        f.write(f"Total Time: {sum(query_times.values())}\n")


# Function to plot horizontal histogram
def plot_histogram(query_times, scale_factor, uid):
    filename = f"results/power_test_sf={scale_factor}_{uid}.png"
    # Create the horizontal bar chart
    filenames, times = zip(*query_times.items())
    query_times_df = pd.DataFrame({"Query Number": filenames, "Time (seconds)": times})
    # Create the Seaborn plot
    plt.figure(figsize=(10, 30))  # Increase the vertical size
    ax = sns.barplot(
        x="Time (seconds)", y="Query Number", data=query_times_df, orient="h"
    )
    # Label the axes
    plt.xlabel("Time (seconds)", fontsize=12)
    plt.ylabel("Query Number", fontsize=12)
    # Increase y-tick font size
    ax.set_yticklabels(ax.get_yticklabels(), size=5)
    # Add title
    plt.title(f"Time Taken for Each Query. SF={scale_factor}", fontsize=14)
    # Show the plot
    plt.savefig(filename)
    # plt.show()


def power_test(scale_factor, queries_directory, uid):
    total_time = 0
    try:
        database = "tpcds" if scale_factor == 1 else f"tpcds{scale_factor}"
        conn = mysql.connector.connect(
            host="localhost",
            user="root",
            password="password",
            database=database,
            charset="utf8",
            consume_results=True,
        )
        cursor = conn.cursor()
        queries = read_sql_files(queries_directory)
        query_times = execute_queries(queries, cursor)
        total_time = sum(query_times.values())
    except mysql.connector.Error as e:
        print(f"Connection failed: {e}")
    except KeyboardInterrupt:
        print("User interrupted the process.")
    else:
        save_results_to_file(query_times, scale_factor, uid)
        plot_histogram(query_times, scale_factor, uid)
    finally:
        cursor.close()
        conn.close()
        return total_time


def main():
    # Specify the directory containing the SQL files
    parser = argparse.ArgumentParser(
        description="Perform power test (provide SF and location of queries)"
    )
    parser.add_argument(
        "--sf", type=int, default=1, help="An integer input for SF. Default is 1."
    )
    parser.add_argument(
        "--qdir",
        type=str,
        default="queries/1/qmod",
        help="Directory for queries to execute",
    )
    args = parser.parse_args()
    uid = datetime.now().strftime("%m-%d_%H-%M-%S")
    # Run the power test
    power_test(args.sf, args.qdir, uid)


if __name__ == "__main__":
    main()

    # use if running on mysql shell
    # sf = 1
    # perform_power_test(sf, f"queries/{sf}/qmod")
    # perform_power_test(sf, f"queries/{sf}/qmod_opt")
    # sf = 2
    # perform_power_test(sf, f"queries/{sf}/qmod")
    # perform_power_test(sf, f"queries/{sf}/qmod_opt")
    # sf = 4
    # perform_power_test(sf, f"queries/{sf}/qmod")
    # perform_power_test(sf, f"queries/{sf}/qmod_opt")
    # sf = 8
    # perform_power_test(sf, f"queries/{sf}/qmod")
    # perform_power_test(sf, f"queries/{sf}/qmod_opt")
