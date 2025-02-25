/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ilyas-guney <ilyas-guney@student.42.fr>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/25 03:08:32 by ilyas-guney       #+#    #+#             */
/*   Updated: 2025/02/25 04:52:22 by ilyas-guney      ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minitalk.h"

volatile sig_atomic_t signal_flag;

static void client_handler(int sig) 
{
    if (sig == SIGUSR1) 
    {
		kill(SIGUSR1, sig);
	}
    else if (sig == SIGUSR2)
        kill(SIGUSR2, sig);
}

static void	send_message(int pid, char *message)
{
	int	i;

	i = 0;
	while (*message)
	{
		i = 8;
		while (i--)
		{
			signal_flag = 0;
			if (((*message >> i) & 1) == 1)
				kill(pid, SIGUSR1);
			else
				kill(pid, SIGUSR2);
			if (!signal_flag)
				pause();
		}
		message++;
	}
}

int	main(int argc, char *argv[])
{
	char				*message;
	pid_t				server_pid;
	struct sigaction	sa;

	sa.sa_handler = client_handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(SIGUSR1, &sa, NULL);
	if (argc != 3)
		return (ft_printf("Please enter a valid argument\n"), 1);
	message = argv[2];
	server_pid = ft_atoi(argv[1]);
	send_message(server_pid, message);
	return (0);
}