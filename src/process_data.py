import os

import pandas as pd

data_dir = './data'


def process_activity_details():
    directory_path = os.path.join(data_dir, 'activities')
    output_file_path = os.path.join(data_dir, 'activity_details.csv')
    dataframes = []

    for filename in os.listdir(directory_path):
        if filename.endswith('.csv'):
            file_path = os.path.join(directory_path, filename)
            df = pd.read_csv(file_path)

            # set hr = None if the column doesn't exist
            if 'hr' not in df.columns:
                df['hr'] = None

            df = df[['ele', 'lat', 'lon', 'time', 'hr']]

            df['Activity ID'] = filename.split(".")[0]
            df = df.sample(frac=0.1, random_state=42)
            dataframes.append(df)

    merged_df = pd.concat(dataframes, axis=0, join='outer')
    merged_df.to_csv(output_file_path, index=False)


def process_activities_csv():
    activities_csv_path = os.path.join(data_dir, 'activities.csv')
    activities_df = pd.read_csv(activities_csv_path)

    activities_df_columns = ['Activity ID', 'Activity Date', 'Activity Name', 'Activity Type', 'Activity Gear',
                             'Distance', 'Moving Time', 'Average Speed', 'Total Steps', 'Elevation Gain',
                             'Average Heart Rate', 'Average Watts', 'Calories']

    activities_df = activities_df[activities_df_columns]
    activities_df = activities_df[activities_df['Activity Type'].isin(['Walk', 'Ride', 'Hike'])]

    # Unit conversions
    activities_df['Distance'] = activities_df['Distance'] * 0.621371
    activities_df['Average Speed'] = activities_df['Average Speed'] * 2.23694
    activities_df['Elevation Gain'] = activities_df['Elevation Gain'] * 3.28084

    activities_df.to_csv(activities_csv_path, index=False)


if __name__ == '__main__':
    process_activities_csv()
    process_activity_details()
