﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Client.EventArguments;

namespace Client.Logic.Contracts
{
    public interface ILoginService
    {
        void Login(string username, string password, string ip, string port);
    }
}
